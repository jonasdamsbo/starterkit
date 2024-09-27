﻿using myshared.DTOs;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace myshared.Models
{
    public class NosqlExampleModel
    {
		[BsonId]
		[BsonRepresentation(BsonType.ObjectId)]
		public string Id { get; set; }
		[BsonElement("Title")]
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public NosqlExampleModel() { }
		public NosqlExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id.ToString(), exampleDTO.Title, exampleDTO.Description);
	}
}