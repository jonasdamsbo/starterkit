using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using myshared.DTOs;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace myshared.Models
{
    public class ExampleModel // Combined to be nosql/mssql agnostic
    {
		// primary key
		[Key] // required for mssql
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)] // required for mssql
		[BsonId] // required for nosql
		[BsonRepresentation(BsonType.ObjectId)] // required for nosql
		public string Id { get; set; }
		[BsonElement("Title")] // required for nosql
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		[JsonIgnore] // required for mssql
		public virtual List<ExampleNavigationProperty> ExampleNavigationProperty { get; set; }

		public ExampleModel() { }
		public ExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description, ExampleNavigationProperty) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description, exampleDTO.ExampleNavigationProperty);
	}
}