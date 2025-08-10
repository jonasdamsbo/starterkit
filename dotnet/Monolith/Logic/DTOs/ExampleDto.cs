using Monolith.Data.Models;
using Monolith.Query.Aggregates;
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
		public ExampleDTO(ExampleAggregate example) =>
		(Id, Title, Description, ExampleNavigationProperties) = (example.Id, example.Title, example.Description,
			example.ExampleNavigationProperties.Select(x => new ExampleNavigationPropertyDTO(x)).ToList()
		);
		public ExampleDTO(ExampleModel example) =>
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