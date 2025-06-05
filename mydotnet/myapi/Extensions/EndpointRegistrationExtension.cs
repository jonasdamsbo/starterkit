//using myapi.Route.API.Endpoints;

namespace myapi.Extensions
{
	public static class EndpointRegistrationExtension
	{
		public static IEndpointRouteBuilder MapAllEndpoints(this WebApplication app)
		{
			//app.MapTestEndpoints();

			return app;
		}
	}
}
