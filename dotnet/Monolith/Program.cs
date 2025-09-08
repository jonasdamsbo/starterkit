using Microsoft.EntityFrameworkCore;
using Monolith.Extensions;
using Monolith.UI.GUI;
using Microsoft.EntityFrameworkCore.Proxies;
using Monolith.Data;
using Monolith.Data.Models;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
	options.IdleTimeout = TimeSpan.FromMinutes(30); // Customize as needed
	options.Cookie.HttpOnly = true;
	options.Cookie.IsEssential = true;
});

// Add services to the container.
builder.Services.AddRazorComponents()
	.AddInteractiveServerComponents();


// detailed frontend errors
builder.Services.AddServerSideBlazor().AddCircuitOptions(options => { options.DetailedErrors = true; });

// add services v
builder.Services.RegisterServices();
// add services ^

// for mssql v

//var env = builder.Environment;

//if (!env.IsProduction()/*env.IsDevelopment() || env.IsEnvironment("Test")*/)
//{
//	builder.Services.AddDbContext<MssqlDataContext>(options =>
//		options.UseInMemoryDatabase("DevOrTestDb"));
//}
//else
//{
//	builder.Services.AddDbContext<MssqlDataContext>(options => options
//   .UseSqlServer(builder.Configuration.GetConnectionString("Mssql")));
//}
builder.Services.AddDbContext<MssqlDataContext>(options => options
   .UseSqlServer(builder.Configuration.GetConnectionString("Mssql")));
//.UseLazyLoadingProxies()); // for enabling lazy loading
//.EnableSensitiveDataLogging(true));

// for mssql ^

var app = builder.Build();

app.UseSession();

// do stuff on first app load v
app.RunOnStartup();
// do stuff on first app load ^

// do stuff on every http request except specified routes v
app.UseCustomMiddleware();
// do stuff on every http request except specified routes ^

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
	app.UseExceptionHandler("/Error", createScopeForErrors: true);
	// The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
	app.UseHsts();
}

app.UseHttpsRedirection();

//app.UseStaticFiles();



// css serving if the files are outside wwwroot
app.UseStaticFiles(); // still serve wwwroot

app.UseStaticFiles(new StaticFileOptions // serve css files from ../Route/UI/Layout/AtomicCSS/ as styles/ or atomic/ or root
{
	FileProvider = new PhysicalFileProvider(
		Path.Combine(builder.Environment.ContentRootPath, "UI", "GUI", "Layout", "AtomicCSS")),
	RequestPath = "/atomic" // wwwroot/atomic/ path
	//RequestPath = "/styles" // wwwroot/styles/ path
	//RequestPath = "" // root path, same as wwwroot/app.css
});



app.UseAntiforgery();

app.MapRazorComponents<App>()
	.AddInteractiveServerRenderMode();

// map all custom endpoints from extension v
app.MapAllEndpoints();
// map all custom endpoints from extension ^

app.Run();
