# ASP.NET Core MVC におけるルーティング

## エンドポイント（ASP.NET Core 2.2以降）
`ASP.NET Core 2.2`以降では、ルーティングにはエンドポイント (Endpoint) を使用して、アプリの論理エンドポイントを表します。

#### Routeクラス（ASP.NET Core 2.1以前）
※`ASP.NET Core 2.1`以前では`IRouter`の標準実装として`Route` クラスが与えられ、それを用いて設定を行う。
`2.1`以前と`2.2`以降との違いは以下
[スタートアップコードのルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/migration/22-to-30?view=aspnetcore-3.1&tabs=visual-studio#routing-startup-code)

## サンプルコード
VisualStudioからMVCを選んで自動生成される`Startup`クラスは以下。

``` cs
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace SampleNetCoreMVC
{
	public class Startup
	{
		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;
		}

		public IConfiguration Configuration { get; }

		// This method gets called by the runtime. Use this method to add services to the container.
		public void ConfigureServices(IServiceCollection services)
		{
			services.AddControllersWithViews();
		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{
			if (env.IsDevelopment())
			{
				app.UseDeveloperExceptionPage();
			}
			else
			{
				app.UseExceptionHandler("/Home/Error");
				// The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
				app.UseHsts();
			}
			app.UseHttpsRedirection();
			app.UseStaticFiles();

			app.UseRouting();

			app.UseAuthorization();

			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllerRoute(
					name: "default",
					pattern: "{controller=Home}/{action=Index}/{id?}");
			});
		}
	}
}
```

## 概要
[ASP.NET Core のルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/fundamentals/routing?view=aspnetcore-3.1)
[エンドポイント ルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/fundamentals/routing?view=aspnetcore-3.1#endpoint-routing)
[ASP.NET Core Web アプリケーションでルーティング機能を利用しエンドポイントの作成をする](https://www.ipentec.com/document/csharp-asp-net-core-create-endpoints)
[ASP.NET Core Web アプリケーションでコントローラーへのルーティング、マッピングを作成する](https://www.ipentec.com/document/csharp-asp-net-core-create-map-route-controller-using-endpoints)
- エンドポイント ルーティングは、次の 2 つの拡張メソッドを使ってミドルウェアと統合されます。
    - `UseRouting` により、ミドルウェア パイプラインにルート照合が追加されます。 これは、承認やエンドポイントの実行など、ルート対応のあらゆるミドルウェアの前に配置する必要があります。
    - `UseEndpoints` により、ミドルウェア パイプラインにエンドポイントの実行が追加されます。 これにより、エンドポイントの応答を提供する要求デリゲートが実行されます。 また、UseEndpoints は、アプリによって照合および実行できるルート エンドポイントが構成される場所でもあります。 
      - たとえば、`MapRazorPages`、`MapControllers`、`MapGet`、`MapPost` などです。
- アプリでは、そのルートを構成するために、ASP.NET Core のヘルパー メソッドが使用されます。 
    - ASP.NET Core フレームワークには、`MapRazorPages`、`MapControllers`、`MapHub<THub>` などのヘルパー メソッドが用意されています。 
    - 独自のカスタム ルート エンドポイントを構成するためのヘルパーメソッドもあります。`MapGet`、`MapPost`、および `MapVerb` です。


## 規則ルーティング

## 属性ルーティング