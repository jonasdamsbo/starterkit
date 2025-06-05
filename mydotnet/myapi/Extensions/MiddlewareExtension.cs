using Microsoft.AspNetCore.Http;
using myapi;

namespace myapi.Extensions
{
	public static class MiddlewareExtension
	{
		public static IApplicationBuilder UseCustomMiddleware(this IApplicationBuilder app)
		{
			return app.Use(async (context, next) =>
			{
				// skip middleware for these paths
				var path = context.Request.Path;
				if (path.StartsWithSegments("/session/authenticate") ||
					path.StartsWithSegments("/css") ||
					path.StartsWithSegments("/js") ||
					path.StartsWithSegments("/favicon.ico"))
				{
					await next();
					return;
				}

				// dependency injection
				var logger = context.RequestServices.GetRequiredService<ILoggerFactory>()
				   .CreateLogger("CustomMiddleware");

				// abort request if somecheck
				bool? someCheck = true;
				if (someCheck is false or null) return;

				// set session if session is null
				var hasSession = context.Session.GetString(Constants.Session.hasSession) is "true" ? true : false;
				if (!hasSession)
				{
					context.Session.SetString(Constants.Session.hasSession, "true");
					logger.LogInformation("Session has been set");
				}

				// if session is loaded
				if (hasSession)
				{
					logger.LogInformation("Running session middleware");

					// do some stuff first request
					UseCustomFirstRequestMiddleware(context, logger);

					// do some stuff before every request
					logger.LogInformation("Before request middleware has finished");

					// forward request and await
					await next();

					// do some stuff after every request
					logger.LogInformation("After request middleware has finished");
				}
				else
				{
					await next();
				}
			});
		}
		public static void UseCustomFirstRequestMiddleware(HttpContext context, ILogger logger)
		{
				var hasRun = context.Session.GetString(Constants.Session.hasRun) is "true";
				if (!hasRun)
				{
					context.Session.SetString(Constants.Session.hasRun, "true");
					// do some stuff on the first request that has session set
					logger.LogInformation("First request middleware has finished");
				}
		}
	}
}
