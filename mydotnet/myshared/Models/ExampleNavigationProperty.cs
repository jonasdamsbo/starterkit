using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations;

namespace myshared.Models
{
    public class ExampleNavigationProperty
	{
		// primary key
		[Key]
		[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
		public string Id { get; set; }
		public string? Title { get; set; }

		// foreign key
		//[JsonIgnore]
		public required virtual ExampleModel ExampleModel { get; set; }
		[ForeignKey(nameof(ExampleModel))]
		public required string ExampleModelId { get; set; }

		public ExampleNavigationProperty() {
			Id = Guid.NewGuid().ToString();
		 }
	}
}