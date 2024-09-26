using myshared.DTOs;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace myshared.Models
{
    public class NosqlExampleModel
    {
		[BsonId]
		[BsonRepresentation(BsonType.ObjectId)]
		public int Id { get; set; }
		[BsonElement("Title")]
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public NosqlExampleModel() { }
		public NosqlExampleModel(PortfolioProjectDTO portfolioProjectDTO) =>
		(Id, Title, Description) = (portfolioProjectDTO.Id, portfolioProjectDTO.Title, portfolioProjectDTO.Description);
	}

	public class NosqlExampleDatabaseSettings
	{
		public string ConnectionString { get; set; } = null!;

		public string DatabaseName { get; set; } = null!;

		public string NosqlExampleCollectionName { get; set; } = null!;
	}
}