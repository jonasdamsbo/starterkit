using MongoDB.Bson;
using Monolith.Data.Models;
using Monolith.Logic.DTOs;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace Monolith.Query.Aggregates
{
    public class ExampleAggregate
    {
		public string Id { get; set; }
		public string? Title { get; set; }
        public string? Description { get; set; }
		//public string? WebUrl { get; set; }

		public List<ExampleNavigationPropertyAggregate> ExampleNavigationProperties { get; set; }

		public ExampleAggregate() { }

		// manual mapping, not needed with mapster
		public ExampleAggregate(ExampleDTO exampleDTO) =>
		(Id, Title, Description, ExampleNavigationProperties) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description,
			exampleDTO.ExampleNavigationProperties.Select(x => new ExampleNavigationPropertyAggregate(x)).ToList()
		);

		public ExampleAggregate(ExampleModel example) =>
		(Id, Title, Description, ExampleNavigationProperties) = (example.Id, example.Title, example.Description,
			example.ExampleNavigationProperties.Select(x => new ExampleNavigationPropertyAggregate(x)).ToList()
		);

		//public ExampleDTO ToDto(ExampleDTO newDto)
		//{
		//	return newDto;
		//}
		//public ExampleNavigationPropertyDTO ToDto(ExampleNavigationPropertyDTO exampleDto)
		//{
		//	return new ExampleNavigationPropertyDTO();
		//}
	}
}