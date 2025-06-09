using Monolith.Route.API.Endpoints;

namespace Monolith.Extensions
{
	public static class EndpointRegistrationExtension
	{
		public static IEndpointRouteBuilder MapAllEndpoints(this WebApplication app)
		{
			app.MapTestEndpoints();

			return app;
		}
	}
}
