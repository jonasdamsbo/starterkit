using Microsoft.AspNetCore.Http;

namespace Monolith.Extensions
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

				// check and set session flag
				var hasSession = context.Session.GetString(Constants.Session.hasSession) is "true" ? true : false;
				if (!hasSession) context.Session.SetString(Constants.Session.hasSession, "true");
				else FirstSessionRequest(context);

				// do some stuff before every request here

				// send request through
				await next();

				// do some stuff after every request here
			});
		}
		public static void FirstSessionRequest(HttpContext context)
		{
			// check and set firstrequest flag
			var hasRun = context.Session.GetString(Constants.Session.hasRun) is "true" ? true : false;
			if (!hasRun)
			{
				context.Session.SetString(Constants.Session.hasRun, "true");

				// do some stuff on the first request that has session set here
			}
		}
	}
}
