using Monolith.Data;

namespace Monolith.Extensions
{
	public static class AppStartupTasksExtension
	{
		public static void RunOnStartup(this IApplicationBuilder app)
		{
			using (var scope = app.ApplicationServices.CreateScope())
			{
				var services = scope.ServiceProvider;

				var logger = services
					.GetRequiredService<ILoggerFactory>()
					.CreateLogger("AppStartupTasksExtension");

				// Do startup tasks here
				//var env = (app as WebApplication)?.Environment;
				//if (!env.IsProduction())
				//{
				//	var db = scope.ServiceProvider.GetRequiredService<MssqlDataContext>();
				//	db.Database.EnsureCreated();
				//}

				logger.LogInformation("Startups tasks has run");
			}
		}
	}
}
