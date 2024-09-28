﻿using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using myshared.DTOs;

namespace myshared.Models
{
    public class ExampleNosqlModel
	{
		[BsonId] // required for nosql
		[BsonRepresentation(BsonType.ObjectId)] // required for nosql
		public string Id { get; set; }
		[BsonElement("Title")] // required for nosql
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public ExampleNosqlModel() { }
		public ExampleNosqlModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description);
	}
}