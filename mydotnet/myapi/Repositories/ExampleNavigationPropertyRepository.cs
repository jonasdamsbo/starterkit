using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;
using System.Linq;

namespace myapi.Repositories
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

        public async Task<List<ExampleNavigationProperty>?> GetAllAsync()
        {
            try
            {
                var examples = await _context.ExampleNavigationProperties
                    .Include(x => x.ExampleModel)
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
        public async Task<List<ExampleNavigationProperty>?> GetByExampleModelIdAsync(string exampleModelId)
        {
            try
            {
                var exampleNavProps = await _context.ExampleNavigationProperties
                    .Where(x => x.ExampleModel.Id == exampleModelId)
                    .Include(x => x.ExampleModel)
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

        public async Task<ExampleNavigationProperty?> GetByIdAsync(string id)
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

        public async Task<ExampleNavigationProperty?> AddAsync(ExampleNavigationProperty newModel)
        {
            try
            {
                //if((await GetByIdAsync(newModel.Id)) != null) return null;
                newModel.Id = ObjectId.GenerateNewId().ToString();

                _context.Add(newModel);
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

        public async Task<ExampleNavigationProperty?> UpdateAsync(string id, ExampleNavigationProperty updatedModel)
        {
            try
            {
                var example = await GetByIdAsync(id);

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

        public async Task<ExampleNavigationProperty?> DeleteAsync(string id)
        {
            try
            {
                var example = await GetByIdAsync(id);

                _context.ExampleNavigationProperties.Remove(example);
                await _context.SaveChangesAsync();

                return example;
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