
import PathKit
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

class MoviePath {
    static let moviePath = "/Users/liuruilong/Movies/Movie/"
    init() {
    }
    var movies: [String: Any] = {
        let path = Path.init(MoviePath.moviePath)
        do {
            let inMovies = try path.children().map{$0.absolute().abbreviate().string.lastFilePathComponent}
            return ["path" : MoviePath.moviePath, "movies" : inMovies] as [String : Any]
        } catch  {
            fatalError(error.localizedDescription)
        }
    }()
    
    func remove(file: String) {
        let shell = Shell.init(order: "rm", arguments: [MoviePath.moviePath + file], orderPath: "/bin/")
        shell.run()
    }
    
    func open(file: String) {
        let shell = Shell.init(order: "open", arguments: [MoviePath.moviePath + file])
        shell.run()
    }
}

let server = HTTPServer.init()
let movies = MoviePath.init()
var routes = Routes.init()

let routeAll = Route.init(method: .post, uri: "/all") { (request, response) in
    do{
        try response.setBody(json: movies.movies)
    }catch{
        fatalError(error.localizedDescription)
    }
    response.setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
    response.completed()
}

let routeDelete = Route.init(method: .post, uri: "/delete") { (request, response) in
    response.setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
    if let fileName = request.param(name: "file"){
        movies.remove(file: fileName)
        response.setBody(string: "ok")
    }else{
        response.setBody(string: "need file parameter")
    }
    response.completed()
}

let routeOpen = Route.init(method: .post, uri: "/open") { (request, response) in
    response.setHeader(HTTPResponseHeader.Name.contentType, value: "application/json")
    if let fileName = request.param(name: "file"){
        movies.open(file: fileName)
        response.setBody(string: "ok")
    }else{
        response.setBody(string: "need file parameter")
    }
    response.completed()
}

routes.add([routeAll, routeOpen, routeDelete])

server.addRoutes(routes)

server.serverPort = 8181
do{
    try server.start()
}catch{
    print("网络开启出错")
}


