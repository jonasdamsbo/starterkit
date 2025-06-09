using Monolith.Logic.DTOs;
using Monolith.Query.Projections;

namespace Monolith.Data.Models
{
	public class DtoMapper
	{
		public ExampleDTO ToExampleDTO(ExampleProjection model)
		{
			var dto = new ExampleDTO()
			{
				Id = model.Id,
				Description = model.Description,
				Title = model.Title,
				ExampleNavigationProperties = model.ExampleNavigationProperties
						.Select(navProp => ToExampleNavigationPropertyDTO(navProp)).ToList()
			};
			return dto;
		}

		public ExampleNavigationPropertyDTO ToExampleNavigationPropertyDTO(ExampleNavigationPropertyProjection model)
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
