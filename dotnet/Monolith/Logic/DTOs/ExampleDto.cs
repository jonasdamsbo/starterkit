using Monolith.Query.Projections;
using System.Linq;
using System.Text.Json.Serialization;

namespace Monolith.Logic.DTOs
{
	public class ExampleDTO
	{
		public string? Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public List<ExampleNavigationPropertyDTO>? ExampleNavigationProperties { get; set; }


		public ExampleDTO() { }
		public ExampleDTO(ExampleProjection example) =>
		(Id, Title, Description, ExampleNavigationProperties) = (example.Id, example.Title, example.Description,
			example.ExampleNavigationProperties.Select(x => new ExampleNavigationPropertyDTO(x)).ToList()
		);
	}
	//public enum DtoTypes
	//{
	//	ExampleDTO,
	//	ExampleNavigationPropertyDTO
	//}
}