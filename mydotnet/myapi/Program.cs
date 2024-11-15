using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myapi.Repositories;
using myapi.Services;
using myshared.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container. // standard

// controller - outcomment to use endpoints v
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
builder.Services.AddSwaggerGen(c =>
{
	// use these options to avoid swagger error when endpoint/controller methods has same names
	c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
});

// mssql database context and connectionstring
builder.Services.AddDbContext<MssqlDataContext>(options =>
	options.UseSqlServer(builder.Configuration.GetConnectionString("Mssql")));
	//.EnableSensitiveDataLogging(true));

// add services
builder.Services.AddScoped<AzureService>();
builder.Services.AddScoped<EnvironmentVariableService>();
builder.Services.AddScoped<ExampleModelService>();
builder.Services.AddScoped<ExampleNavigationPropertyService>();

// add repositories
builder.Services.AddScoped<ExampleModelRepository>();
builder.Services.AddScoped<ExampleNavigationPropertyRepository>();

// to run/deploy 2 projects in a single app
builder.Services.Configure<IISOptions>(options =>
{
	options.ForwardClientCertificate = false;
});

// build app
var app = builder.Build();

// update-database on build
using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;
	
	// test azure cli/devops
	var azure = services.GetRequiredService<AzureService>();
    //var x = azure.GetResourcesList();

    // using your manually created migrations, automatically runs update-database 
    var context = services.GetRequiredService<MssqlDataContext>();
    context.Database.Migrate();
}

// Configure the HTTP request pipeline. 
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();
app.MapControllers();

app.Run();