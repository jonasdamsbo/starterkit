using myshared.DTOs;
using Mapster;

namespace myshared.Models
{
	public class MapsterConfig
	{
		public void ConfigureMapster()
		{
			TypeAdapterConfig<ExampleModel, ExampleDTO>.NewConfig();
			TypeAdapterConfig<ExampleNavigationProperty, ExampleNavigationPropertyDTO>.NewConfig();

			// custom maps
			TypeAdapterConfig<ExampleModel, ExampleDTO>.NewConfig()
				.Map(dest => dest.ExampleNavigationPropertiesDTO, src => src.ExampleNavigationProperties
					.Select(navProp => new ExampleNavigationPropertyDTO()
					{
						Id = navProp.Id,
						Title = navProp.Title
					}).ToList()
				);
		}
	}
}
