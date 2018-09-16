Shader "KeyStone/KeyStone"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[HideInspector] __width("__width", Float) = 1280
		[HideInspector] __height("__hright", Float) = 720
		_upperSide("Upper Side", Range(0.0, 2.0)) = 1.0
		_lowerSide("Lower Side", Range(0.0, 2.0)) = 1.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform half __width;
			uniform half __height;
			uniform half _upperSide;
			uniform half _lowerSide;

			fixed4 frag (v2f_img i) : SV_Target
			{
				// uv.xをスケーリング
				// uv.xを[0 - 1]から[-1 - 1]に変換する
				half uvx = (i.uv.x * 2.0) - 1.0;

				// xの拡大率を算出
				// upperSide と _lowerSide を線形補間させる
				half xScale = (_upperSide * i.uv.y) + (_lowerSide * (1.0 - i.uv.y));

				// uv.xを算出
				uvx /= xScale;

				// uvを[-1 - 1]から[0 - 1]に変換する
				uvx = (uvx + 1.0) * 0.5;



				// uv.yをスケーリング
				half ratio = _upperSide / _lowerSide;
				half uvy = (i.uv.y / ((ratio - 1) * i.uv.y + 1)) * ratio;

				half2 uv = half2(uvx, uvy);

				fixed4 col = tex2D(_MainTex, uv);

				//// Bilinearで拡大サンプリング
				//// 座標を取得
				//half2 scaleCoord = half2(__width * uv.x, __height * uv.y);

				//// 元画像からのサンプリング座標を取得
				////half2 sampleCoord = half2(floor(scaleCoord.x / xScale), floor(scaleCoord.y / xScale));
				//half2 sampleCoord = half2(floor(scaleCoord.x), floor(scaleCoord.y));
				//sampleCoord = half2(sampleCoord.x / __width, sampleCoord.y / __height);

				//// 距離を求める
				////half2 distance = half2(scaleCoord.x - sampleCoord.x, scaleCoord.y - sampleCoord.y);
				//half distance = 1 / xScale;

				//fixed4 col = tex2D(_MainTex, sampleCoord);
				
				/*fixed4 col = tex2D(_MainTex, uv) * (1.0 - distance.x) * (1.0 - distance.y)
					+ tex2D(_MainTex, half2(uv.x + 1, uv.y)) * distance.x * (1.0 - distance.y)
					+ tex2D(_MainTex, half2(uv.x, uv.y + 1)) * (1.0 - distance.x) * distance.y
					+ tex2D(_MainTex, half2(uv.x + 1, uv.y + 1)) * distance.x * distance.y;*/

				return col;
			}
			ENDCG
		}
	}
}
