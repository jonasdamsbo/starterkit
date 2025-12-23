using MongoDB.Bson;
using Monolith.Logic.DTOs;
using Monolith.Query.Aggregates;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace Monolith.Data.Models
{
    public class ExampleModel
    {
		// primary key
		[Key]
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
		public string Id { get; set; }
		public string? Title { get; set; }
        public string? Description { get; set; }
		//public string? WebUrl { get; set; }

		[JsonIgnore]
		public virtual List<ExampleNavigationProperty> ExampleNavigationProperties { get; set; }

		public ExampleModel() {
			Id = ObjectId.GenerateNewId().ToString();
		 }

		// manual mapping, not needed with mapster
		public ExampleModel(ExampleAggregate exampleAggregate) =>
		(Id, Title, Description, ExampleNavigationProperties) = (exampleAggregate.Id, exampleAggregate.Title, exampleAggregate.Description,
			exampleAggregate.ExampleNavigationProperties.Select(x => new ExampleNavigationProperty(x)).ToList()
		);
		public ExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description, ExampleNavigationProperties) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description,
			exampleDTO.ExampleNavigationProperties.Select(x => new ExampleNavigationProperty(x)).ToList()
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