namespace myapi.Data
{
	public class NosqlDataContext
	{
		public string ConnectionString { get; set; } = null!;

		public string DatabaseName { get; set; } = null!;

		public string ExampleCollectionName { get; set; } = null!;
	}
}
