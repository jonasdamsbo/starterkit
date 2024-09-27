﻿using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using myshared.DTOs;

namespace myshared.Models
{
    public class MssqlExampleModel
    {
		[BsonId] // for nosql
		[BsonRepresentation(BsonType.ObjectId)] // for nosql
		public string Id { get; set; }
		[BsonElement("Title")] // for nosql
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public MssqlExampleModel() { }
		public MssqlExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description);
	}
}