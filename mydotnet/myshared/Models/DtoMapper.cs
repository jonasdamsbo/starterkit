using myshared.DTOs;

namespace myshared.Models
{
	public class DtoMapper
	{
		public ExampleDTO ToExampleDTO(ExampleModel model)
		{
			var dto = new ExampleDTO()
			{
				Id = model.Id,
				Description = model.Description,
				Title = model.Title,
				ExampleNavigationPropertiesDTO = model.ExampleNavigationProperties
						.Select(navProp => ToExampleNavigationPropertyDTO(navProp)).ToList()
			};
			return dto;
		}
		public ExampleNavigationPropertyDTO ToExampleNavigationPropertyDTO(ExampleNavigationProperty model)
		{
			var dto = new ExampleNavigationPropertyDTO()
			{
				Id = model.Id,
				Title = model.Title
			};
			return dto;
		}
	}
}
