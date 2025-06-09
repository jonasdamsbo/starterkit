using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
//using MongoDB.Driver;
using Monolith.Data;
using Monolith.Data.Models;
using Monolith.Logic.DTOs;
using Monolith.Query.Projections;
using System.Linq;

namespace Monolith.Query.Repositories
{
    public class ExampleNavigationPropertyRepository// : IRepository
    {
        private readonly MssqlDataContext _context;
        private ILogger<ExampleModelRepository> _log;

        public ExampleNavigationPropertyRepository(MssqlDataContext context,
            ILogger<ExampleModelRepository> log)
        {
            _context = context;
            _log = log;
        }

        public async Task<List<ExampleNavigationPropertyProjection>?> GetAllAsync()
        {
            try
            {
                var examples = await _context.ExampleNavigationProperties
					.Include(x => x.ExampleModel)
					.Select(x => new ExampleNavigationPropertyProjection
					{
						Id = x.Id,
						Title = x.Title,
						ExampleProjection = new ExampleProjection(x.ExampleModel)
					})
                    .ToListAsync();

                return examples;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        // should be in all repositories whos model uses a foreign key
        public async Task<List<ExampleNavigationPropertyProjection>?> GetByExampleModelIdAsync(string exampleModelId)
        {
            try
            {
                var exampleNavProps = await _context.ExampleNavigationProperties
                    .Where(x => x.ExampleModel.Id == exampleModelId)
                    .Include(x => x.ExampleModel)
					.Select(x => new ExampleNavigationPropertyProjection
					{
						Id = x.Id,
						Title = x.Title,
						ExampleProjection = new ExampleProjection(x.ExampleModel)
					})
					.ToListAsync();

                return exampleNavProps;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/GetAllRelatedToIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/GetAllRelatedToIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleNavigationPropertyProjection?> GetByIdAsync(string id)
        {
            try
            {
                var exampleNavProp = await _context.ExampleNavigationProperties
                    .Where(x => x.ExampleModel.Id == id)
                    .Include(x => x.ExampleModel)
					.Select(x => new ExampleNavigationPropertyProjection
					{
						Id = x.Id,
						Title = x.Title,
						ExampleProjection = new ExampleProjection(x.ExampleModel)
					})
					.FirstOrDefaultAsync();

                return exampleNavProp;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

		private async Task<ExampleNavigationProperty?> GetByIdAsyncModel(string id)
		{
			try
			{
				var exampleNavProp = await _context.ExampleNavigationProperties
					.Where(x => x.ExampleModel.Id == id)
					.Include(x => x.ExampleModel)
					.FirstOrDefaultAsync();

				return exampleNavProp;
			}
			catch (Exception ex)
			{
				_log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
				Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console

				return null;
			}
		}

		public async Task<ExampleNavigationPropertyProjection?> AddAsync(ExampleNavigationPropertyDTO newModel)
        {
            try
            {
                //if((await GetByIdAsync(newModel.Id)) != null) return null;
                newModel.Id = ObjectId.GenerateNewId().ToString();

                var example = new ExampleNavigationProperty(newModel);

                _context.Add(example);
                await _context.SaveChangesAsync();

                var newExample = await GetByIdAsync(newModel.Id);

                return newExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/AddAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/AddAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleNavigationPropertyProjection?> UpdateAsync(string id, ExampleNavigationPropertyDTO updatedModel)
        {
            try
            {
                var example = await GetByIdAsyncModel(id);

                example.Title = updatedModel.Title;
                await _context.SaveChangesAsync();

                var updatedExample = await GetByIdAsync(id);

                return updatedExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/UpdateAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/UpdateAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleNavigationPropertyProjection?> DeleteAsync(string id)
        {
            try
            {
                var example = await GetByIdAsyncModel(id);

                _context.ExampleNavigationProperties.Remove(example);
                await _context.SaveChangesAsync();

                var returnExample = new ExampleNavigationPropertyProjection(example);

				return returnExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleNavigationPropertyRepository/DeleteAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleNavigationPropertyRepository/DeleteAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }
    }
}