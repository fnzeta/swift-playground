import Vapor

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewares = MiddlewareConfig() 
    middlewares.use(FileMiddleware.self) 
    middlewares.use(ErrorMiddleware.self) 
    services.register(middlewares)
}
