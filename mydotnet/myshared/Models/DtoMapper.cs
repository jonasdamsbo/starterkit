using myshared.DTOs;

namespace myshared.Models
{
	public class DtoMapper
	{
		public ExampleDTO Map(ExampleModel model, ExampleDTO newDto)
		{
			newDto = new ExampleDTO()
			{
				Id = model.Id,
				Description = model.Description,
				Title = model.Title,
				ExampleNavigationPropertiesDTO = model.ExampleNavigationProperties
						.Select(navProp => Map(navProp, new ExampleNavigationPropertyDTO())).ToList()
			};
			return newDto;
		}
		public ExampleNavigationPropertyDTO Map(ExampleNavigationProperty model, ExampleNavigationPropertyDTO newDto)
		{
			newDto = new ExampleNavigationPropertyDTO()
			{
				Id = model.Id,
				Title = model.Title
			};
			return newDto;
		}
	}
}
