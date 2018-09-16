using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class KeyStone : MonoBehaviour {

    [Header("PostProcessingをかけるShader")]
    public Shader shader;

    //Material Property
    [Range(0, 5)]
    public float UpperSide;
    [Range(0, 5)]
    public float LowerSide;

    // PostProcessingシェーダーをもつMaterial
    private Material _material;
    private Material material
    {
        get
        {
            if(_material == null)
            {
                _material = new Material(shader);
                // スクリプトから生成したマテリアルは保存しないようにする
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        }
    }

    /// <summary>
    /// Materiakの設定を行う
    /// </summary>
    private void SetMaterial()
    {
        // TODO materialの設定を行う
        if (material.HasProperty("__width")) { material.SetFloat("__width", Screen.width); }
        if (material.HasProperty("__height")) { material.SetFloat("__height", Screen.height); }
        if (material.HasProperty("_upperSide")) { material.SetFloat("_upperSide", UpperSide); }
        if(material.HasProperty("_lowerSide")) { material.SetFloat("_lowerSide", LowerSide); }
    }

	// Use this for initialization
	void Start () {
        if ( !SystemInfo.supportsImageEffects           // イメージエフェクトが使用可能か
            || shader == null || shader.isSupported){   // shaderが使用可能か
            // 自身のgameObjectを非活性にする
            enabled = false;
            return;
        }

        // Material の設定を行う
        SetMaterial();
	}

    /// <summary>
    /// レンダリング後に呼ばれるコールバック
    /// </summary>
    /// <param name="source">レンダリング結果</param>
    /// <param name="destination">書き込み先</param>
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
#if UNITY_EDITOR
        // エディター上ではインスペクタ上からの変更を反映させるためここでmaterialを再設定する
        SetMaterial();
#endif
        // source に materialを適用してdestinationに書き込み
        source.filterMode = FilterMode.Trilinear;
        Graphics.Blit(source, destination, material);
    }

    /// <summary>
    /// GameObjectが破棄される際に呼ばれるコールバック
    /// </summary>
    private void OnDestroy()
    {
        // materialを破棄
        if (_material)
        {
            Destroy(_material);
        }
    }
}
