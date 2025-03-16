using myapi.Repositories;
using myapi.Services;
using myapi.Utility;
using myshared.Models;
using myshared.Services;

namespace myapi.Extensions
{
	public static class ServiceRegistratonExtension
	{
		public static IServiceCollection RegisterServices(this IServiceCollection services)
		{
			// add services
			//builder.Services.AddScoped<AzureUtility>();
			services.AddScoped<EnvironmentVariableService>();
			services.AddScoped<ExampleModelService>();
			services.AddScoped<ExampleNavigationPropertyService>();
			services.AddScoped<BackupDbUtility>();

			services.AddScoped<DtoMapper>();

			// add repositories
			services.AddScoped<IExampleModelRepository, ExampleModelRepository>();
			services.AddScoped<ExampleNavigationPropertyRepository>();

			return services;
		}
	}
}
