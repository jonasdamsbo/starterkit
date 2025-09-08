using Monolith.Data.Models;
using Monolith.Logic.DTOs;
using System.Text.Json.Serialization;

namespace Monolith.Query.Aggregates
{
	public class ExampleNavigationPropertyAggregate
	{
		public string? Id { get; set; }
		public string? Title { get; set; }

		public ExampleAggregate? ExampleAggregate { get; set; }

		public ExampleNavigationPropertyAggregate() { }

		public ExampleNavigationPropertyAggregate(ExampleNavigationProperty example) =>
		(Id, Title, ExampleAggregate) = (example.Id, example.Title, new ExampleAggregate(example.ExampleModel));

		public ExampleNavigationPropertyAggregate(ExampleNavigationPropertyDTO example) =>
		(Id, Title, ExampleAggregate) = (example.Id, example.Title, new ExampleAggregate(example.ExampleDTO));

		// manual mapping, not needed with mapster
		/*public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);*/
	}
}