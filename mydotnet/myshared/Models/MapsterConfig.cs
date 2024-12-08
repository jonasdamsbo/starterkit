using myshared.DTOs;
using Mapster;

namespace myshared.Models
{
	public class MapsterConfig
	{
		public void ConfigureMapster()
		{
			TypeAdapterConfig<ExampleModel, ExampleDTO>.NewConfig();
			
			// custom maps
			//TypeAdapterConfig<ExampleModel, ExampleDTO>.NewConfig()
			//	.Map(dest => dest.Description, src => src.Description);
		}
	}
}
