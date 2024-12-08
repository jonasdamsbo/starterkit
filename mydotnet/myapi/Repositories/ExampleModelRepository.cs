using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;

namespace myapi.Repositories
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

        public async Task<List<ExampleModel>?> GetAllAsync()
        {
            try
            {
                var examples = await _context.ExampleModels.ToListAsync();

                return examples;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/GetAllAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleModel?> GetByIdAsync(string id)
        {
            try
            {
                var example = await _context.ExampleModels.FindAsync(id);

                return example;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/GetByIdAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleModel?> AddAsync(ExampleModel newModel)
        {
            try
            {
                //if((await GetByIdAsync(newModel.Id)) != null) return null;
                //newModel.Id = ObjectId.GenerateNewId().ToString();

                _context.Add(newModel);
                await _context.SaveChangesAsync();

                var newExample = await GetByIdAsync(newModel.Id);

                return newExample;
            }
            catch (Exception ex)
            {
                _log.LogError("\r\n" + "\r\n" + "### Exception thrown at 'ExampleModelRepository/AddAsync' --> " + ex.ToString() + " <-- ###" + "\r\n" + "\r\n"); // saved to apptracelogs in azure
                Console.WriteLine("### Exception thrown at 'ExampleModelRepository/AddAsync' --> " + ex.ToString() + " <-- ###"); // shown in app console
                
                return null;
            }
        }

        public async Task<ExampleModel?> UpdateAsync(string id, ExampleModel updatedModel)
        {
            try
            {
                var example = await GetByIdAsync(id);

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

        public async Task<ExampleModel?> DeleteAsync(string id)
        {
            try
            {
                var example = await GetByIdAsync(id);
                
                _context.ExampleModels.Remove(example);
                await _context.SaveChangesAsync();
                
                return example;
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