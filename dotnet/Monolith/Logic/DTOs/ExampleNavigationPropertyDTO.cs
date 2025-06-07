using Monolith.Data.Models;
using System.Text.Json.Serialization;

namespace Monolith.Logic.DTOs
{
	public class ExampleNavigationPropertyDTO
	{
		public string? Id { get; set; }
		public string? Title { get; set; }

		public ExampleNavigationPropertyDTO() { }
		public ExampleNavigationPropertyDTO(ExampleNavigationProperty example) =>
		(Id, Title) = (example.Id, example.Title);

		// manual mapping, not needed with mapster
		/*public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);*/
	}
}