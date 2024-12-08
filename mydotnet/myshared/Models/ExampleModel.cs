using MongoDB.Bson;
using myshared.DTOs;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace myshared.Models
{
    public class ExampleModel
    {
		// primary key
		[Key]
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
		public string Id { get; set; }
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		[JsonIgnore]
		public virtual List<ExampleNavigationProperty>? ExampleNavigationProperty { get; set; }

		public ExampleModel() {
			Id = ObjectId.GenerateNewId().ToString();
		 }

		// manual mapping, not needed with mapster
		/*public ExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description);*/
	}
}