namespace myapi.Extensions
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
				logger.LogInformation("Startups tasks has run");
			}
		}
	}
}
