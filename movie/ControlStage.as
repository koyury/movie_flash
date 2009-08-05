package movie
{
	import flash.display.Loader;
	
	public class ControlStage
	{
		var imgLoader:Loader;
		
		public function ControlStage(loader:Loader)
		{
			imgLoader = loader;
		}
		
		// 関数 resizeBack_mc の定義
		public function resizeBack_mc(stageW:int,stageH:int):void {			
			// 「back_mc」 の縦横の初期サイズを記録
			var backW:Number=imgLoader.content.width;
			var backH:Number=imgLoader.content.height;
			// もしステージの縦横が背景画像より横長であれば
			if (stageH/stageW<backH/backW) {
				imgLoader.content.width=stageW;// 「back_mc」の幅をステージの幅に合わせる
				imgLoader.content.height=stageW*backH/backW;// 「back_mc」の縦をステージの幅を基準に算出
			// もしステージの縦横が背景画像より縦長であれば
			} else {
			imgLoader.content.width=stageH*backW/backH;// 「back_mc」の幅をステージの縦を基準に算出
			imgLoader.content.height=stageH;// 「back_mc」の縦をステージの縦に合わせる
			}
		}
	}
}