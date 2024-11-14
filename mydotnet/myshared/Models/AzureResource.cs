using MongoDB.Bson;
using myshared.DTOs;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace myshared.Models
{
	public class AzureResource
	{
		public string Name { get; set; }
		public string Type { get; set; }
	}
}