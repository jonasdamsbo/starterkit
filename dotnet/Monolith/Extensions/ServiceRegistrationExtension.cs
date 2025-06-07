using Monolith.Data.Models;
using Monolith.Logic.API.Services;
using Monolith.Logic.Services;
using Monolith.Query.Repositories;
//using Monolith.Logic.Utility;

namespace Monolith.Extensions
{
	public static class ServiceRegistrationExtension
	{
		public static IServiceCollection RegisterServices(this IServiceCollection services)
		{
			// Register your services here
			services.AddScoped<TestDtoService>();

			services.AddScoped<EnvironmentVariableService>();
			services.AddScoped<ExampleModelService>();
			services.AddScoped<ExampleNavigationPropertyService>();
			services.AddScoped<TestDtoService>();
			services.AddScoped<TestDtoFactory>();
			services.AddScoped<DtoMapper>();

			// Register your repositories here
			services.AddScoped<IExampleModelRepository, ExampleModelRepository>();
			services.AddScoped<ExampleNavigationPropertyRepository>();

			// More services...

			return services;
		}
	}
}
