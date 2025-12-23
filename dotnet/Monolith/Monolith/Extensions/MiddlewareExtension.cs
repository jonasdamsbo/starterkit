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
				var excludedPaths = ExcludedPaths();
				if (excludedPaths.Any(excludedPath => path.StartsWithSegments(excludedPath)))
				{
					await next();
					return;
				}

				// check and set session flag
				var hasSession = context.Session.GetString(Constants.Session.hasSession) is "true" ? true : false;
				var hasRun = context.Session.GetString(Constants.Session.hasRun) is "true" ? true : false;

				// do stuff on first request (request 1) and first session request (request 2) respectively
				if (!hasSession)
				{
					// set firstrequest flag
					context.Session.SetString(Constants.Session.hasSession, "true");
					FirstRequest();
				}
				else if (!hasRun) 
				{
					// set firstsessionrequest flag
					context.Session.SetString(Constants.Session.hasRun, "true");
					FirstSessionRequest();
				}

				// do some stuff for every request that has a session here (request 2 and onwards)
				hasRun = context.Session.GetString(Constants.Session.hasRun) is "true" ? true : false;
				if (hasRun)
				{
					// do some stuff before every request here
					BeforeSessionRequests();

					// send request through
					await next();

					// do some stuff after every request here
					AfterSessionRequests();
				}
			});
		}
		private static List<PathString> ExcludedPaths()
		{
			return new List<PathString>()
			{
				"/session/authenticate",
				"/css",
				"/js",
				"/favicon.ico"
			};
		}
		private static void FirstRequest()
		{
			// do some stuff on the first request that does not have session set here

		}
		private static void FirstSessionRequest()
		{
			// do some stuff on the first request that has session set here

		}
		private static void BeforeSessionRequests()
		{
			// do some stuff before every request that has session set here

		}
		private static void AfterSessionRequests()
		{
			// do some stuff after every request that has session set here

		}
	}
}
