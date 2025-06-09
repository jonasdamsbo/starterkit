using Monolith.Query.Projections;

namespace Monolith.Query.Repositories
{
	public interface IExampleModelRepository
	{
		Task<List<ExampleProjection>?> GetAllAsync();
		Task<ExampleProjection?> GetByIdAsync(string id);
		Task<ExampleProjection?> AddAsync(ExampleProjection exampleDTO);
		Task<ExampleProjection?> UpdateAsync(string id, ExampleProjection updatedExampleDTO);
		Task<ExampleProjection?> DeleteAsync(string id);
	}
}
