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
		[JsonIgnore]
		public virtual ExampleModel ExampleModel { get; set; }
		[ForeignKey(nameof(ExampleModel))]
		public string ExampleModelId { get; set; }
	}
}