package main

import (
	"context"
	"log"
	"net"
	"net/http"
	"os"

	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "grpc-k8s-sample/proto/go"
)

func main() {
	interceptor := func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler) (resp interface{}, err error) {
		res, err := handler(ctx, req)
		if err != nil {
			log.Printf("error %s", err.Error())
		}
		return res, err
	}

	server := grpc.NewServer(grpc.UnaryInterceptor(interceptor))
	pb.RegisterHelloServer(server, &hello{})
	reflection.Register(server)

	runGRPCServer(server)
	runGRPCWebServer(server)
}

func runGRPCServer(server *grpc.Server) {
	grpcPort := os.Getenv("GRPC_PORT")
	if len(grpcPort) > 0 {
		listener, err := net.Listen("tcp", ":"+grpcPort)
		if err != nil {
			panic(err.Error())
		}

		go func() {
			log.Printf("running grpc server port: %s", grpcPort)
			if err := server.Serve(listener); err != nil {
				panic(err.Error())
			}
		}()
	}
}

func runGRPCWebServer(server *grpc.Server) {
	webPort := os.Getenv("WEB_PORT")
	if len(webPort) == 0 {
		webPort = "3000"
	}

	listener, err := net.Listen("tcp", ":"+webPort)
	if err != nil {
		panic(err.Error())
	}

	mux := http.NewServeMux()

	mux.Handle("/", grpcweb.WrapServer(
		server,
		grpcweb.WithOriginFunc(func(origin string) bool {
			return true
		}),
		grpcweb.WithAllowNonRootResource(true),
	))

	mux.HandleFunc("/health_check", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(http.StatusOK)
	})

	log.Printf("running http server port: %s", webPort)
	if err := http.Serve(listener, mux); err != nil {
		panic(err.Error())
	}
}

type hello struct {
}

func (s *hello) World(ctx context.Context, req *pb.Empty) (*pb.HelloWorld, error) {
	return &pb.HelloWorld{
		Message: "hello world",
	}, nil
}
