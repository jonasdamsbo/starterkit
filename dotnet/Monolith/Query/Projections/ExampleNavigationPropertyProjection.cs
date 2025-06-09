using Monolith.Data.Models;
using Monolith.Logic.DTOs;
using System.Text.Json.Serialization;

namespace Monolith.Query.Projections
{
	public class ExampleNavigationPropertyProjection
	{
		public string? Id { get; set; }
		public string? Title { get; set; }

		public ExampleProjection? ExampleProjection { get; set; }

		public ExampleNavigationPropertyProjection() { }

		public ExampleNavigationPropertyProjection(ExampleNavigationProperty example) =>
		(Id, Title, ExampleProjection) = (example.Id, example.Title, new ExampleProjection(example.ExampleModel));

		public ExampleNavigationPropertyProjection(ExampleNavigationPropertyDTO example) =>
		(Id, Title, ExampleProjection) = (example.Id, example.Title, new ExampleProjection(example.ExampleDTO));

		// manual mapping, not needed with mapster
		/*public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);*/
	}
}