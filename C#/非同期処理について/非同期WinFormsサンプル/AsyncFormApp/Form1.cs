using System;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AsyncFormApp
{
	public partial class Form1 : Form
	{
		public Form1()
		{
			InitializeComponent();
		}

		private void button1_Click(object sender, EventArgs e)
		{
			//逐次処理・同期処理による重い処理
			//UIスレッドは停止
			Thread.Sleep(4560);
			this.textBox1.Text = "A1_Sync Pushed!";
		}

		private async void button4_ClickAsync(object sender, EventArgs e)
		{
			//並列処理・非同期処理による重い処理
			Task<int> task = Task.Run<int>(() =>
			{
				int total = 0;
				for (int i = 1; i <= 200; ++i)
					total += i;
				Thread.Sleep(4560); // 何か重い処理をしている...
				return total;
			});

			//awaitを使用しているのでUIスレッドは停止しない
			int result = await task; // スレッドの処理の結果を「待ち受け」する
			this.textBox1.Text = result.ToString();
		}

		private void button5_Click(object sender, EventArgs e)
		{
			//並列処理・同期処理による重い処理
			Task<int> task = Task.Run<int>(() =>
			{
				int total = 0;
				for (int i = 1; i <= 100; ++i)
					total += i;
				Thread.Sleep(4560); // 何か重い処理をしている...
				return total;
			});

			//ハードウェイティングのTask.Resultを使用しているのでUIスレッドは停止する
			int result = task.Result; // スレッドの処理の結果を「待ち受け」する
			this.textBox1.Text = result.ToString();
		}

		private void button2_Click(object sender, EventArgs e)
		{
			this.textBox2.Text = "B1 Pushed!";

		}

		private void button3_Click(object sender, EventArgs e)
		{
			this.textBox2.Text = "B2 Pushed!";
		}
	}
}