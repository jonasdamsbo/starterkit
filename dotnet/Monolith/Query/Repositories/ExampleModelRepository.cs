using Microsoft.EntityFrameworkCore;
//using MongoDB.Bson;
//using MongoDB.Driver;
using Monolith.Data;
using Monolith.Data.Models;
using Monolith.Query.Projections;

namespace Monolith.Query.Repositories
{
    public class ExampleModelRepository : IExampleModelRepository
	{
        private readonly MssqlDataContext _context;
        private ILogger<ExampleModelRepository> _log;

        public ExampleModelRepository(MssqlDataContext context,
            ILogger<ExampleModelRepository> log)
        {
            _context = context;
            _log = log;
        }

        public async Task<List<ExampleProjection>?> GetAllAsync()
        {
            try
            {
				//var examples = await _context.ExampleModels.ToListAsync(); // lazy
				//var examples = await _context.ExampleModels.Include(x => x.ExampleNavigationProperties).ToListAsync(); // eager

				var examples = await _context.ExampleModels
				.Include(x => x.ExampleNavigationProperties)
				.Select(x => new ExampleProjection
				{
					Id = x.Id,
					Title = x.Title,
					Description = x.Description,
					ExampleNavigationProperties = x.ExampleNavigationProperties.Select(y => new ExampleNavigationPropertyProjection
					{
						Id = y.Id,
						Title = y.Title
					}).ToList()
				})
				.ToListAsync();

				return examples;
			}
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleProjection?> GetByIdAsync(string id)
        {
            try
            {
                var example = await _context.ExampleModels
                    .Where(x => x.Id == id)
                    .Select(x => new ExampleProjection
				    {
					    Id = x.Id,
					    Title = x.Title,
					    Description = x.Description,
					    ExampleNavigationProperties = x.ExampleNavigationProperties
                            .Select(y => new ExampleNavigationPropertyProjection
					        {
						        Id = y.Id,
						        Title = y.Title
					        }).ToList()
				    })
                    .FirstOrDefaultAsync();

                return example;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

		private async Task<ExampleModel?> GetByIdAsyncModel(string id)
		{
			try
			{
				var example = await _context.ExampleModels
					.Where(x => x.Id == id)
					.FirstOrDefaultAsync();

				return example;
			}
			catch (Exception ex)
			{
				_log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
				Console.WriteLine("### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console

				return null;
			}
		}

		public async Task<ExampleProjection?> AddAsync(ExampleProjection newModel)
        {
            try
            {
                //if((await GetByIdAsync(newModel.Id)) != null) return null;
                //newModel.Id = ObjectId.GenerateNewId().ToString();

                var example = new ExampleModel(newModel);

                _context.Add(example);
                await _context.SaveChangesAsync();

                var newExample = await GetByIdAsync(example.Id);

                return newExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/AddAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/AddAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleProjection?> UpdateAsync(string id, ExampleProjection updatedModel)
        {
            try
            {
                var example = await GetByIdAsyncModel(id);

                example.Title = updatedModel.Title;
                example.Description = updatedModel.Description;
                await _context.SaveChangesAsync();

                var updatedExample = await GetByIdAsync(id);

                return updatedExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/UpdateAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/UpdateAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleProjection?> DeleteAsync(string id)
        {
            try
            {
				var example = await GetByIdAsyncModel(id);

				_context.ExampleModels.Remove(example);
                await _context.SaveChangesAsync();

				var returnExample = new ExampleProjection(example);

				return returnExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/DeleteAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/DeleteAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }
    }
}