using Monolith.Data.Models;
using Monolith.Query.Projections;
using System.Text.Json.Serialization;

namespace Monolith.Logic.DTOs
{
	public class ExampleNavigationPropertyDTO
	{
		public string? Id { get; set; }
		public string? Title { get; set; }
		public ExampleDTO? ExampleDTO { get; set; }

		public ExampleNavigationPropertyDTO() { }
		public ExampleNavigationPropertyDTO(ExampleNavigationPropertyProjection example) =>
		(Id, Title, ExampleDTO) = (example.Id, example.Title, new ExampleDTO(example.ExampleProjection));
		public ExampleNavigationPropertyDTO(ExampleNavigationProperty example) =>
		(Id, Title, ExampleDTO) = (example.Id, example.Title, new ExampleDTO(example.ExampleModel));

		// manual mapping, not needed with mapster
		/*public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);*/
	}
}