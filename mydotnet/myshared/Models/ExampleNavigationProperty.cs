using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using myshared.DTOs;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations;

namespace myshared.Models
{
    public class ExampleNavigationProperty // Combined to be nosql/mssql agnostic
	{
		// primary key
		[Key] // required for mssql
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)] // required for mssql
		[BsonId] // required for nosql
		[BsonRepresentation(BsonType.ObjectId)] // required for nosql
		public string Id { get; set; }
		[BsonElement("Title")] // required for nosql
		public string? Title { get; set; }

		// foreign key
		[JsonIgnore] // required for mssql
		public virtual ExampleModel ExampleModel { get; set; }
		[ForeignKey(nameof(ExampleModel))] // required for mssql
		public string ExampleModelId { get; set; }
	}
}