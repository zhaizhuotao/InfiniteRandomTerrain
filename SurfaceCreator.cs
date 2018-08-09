using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class SurfaceCreator : MonoBehaviour {
    public bool analyticalDerivatives;
    public bool showNormals;
    public bool damping;
    public bool coloringForStrength;
    [Range(0f, 1f)]
    public float strength = 1f;
    //public NoiseMethodType type;
    [Range(1, 3)]
    public int dimensions = 3;
    [Range(1, 512)]
    public int resolution = 10;
    [Range(1, 8)]
    public int octaves = 1;
    public float frequency = 1f;
    [Range(1f, 4f)]
    public float lacunarity = 2f;

    [Range(0f, 1f)]
    public float persistence = 0.5f;
    public Gradient coloring;
    public Vector3 offset;
    public Vector3 rotation;
    [SerializeField]
    private Material _material;
    public void Refresh()
    {
        if (resolution != currentResolution)
        {
            CreateGrid();
        }
        //Quaternion q = Quaternion.Euler(rotation);
        //Quaternion qInv = Quaternion.Inverse(q);
        //Vector3 point00 = q * new Vector3(-0.5f, -0.5f) + offset;
        //Vector3 point10 = q * new Vector3(0.5f, -0.5f) + offset;
        //Vector3 point01 = q * new Vector3(-0.5f, 0.5f) + offset;
        //Vector3 point11 = q * new Vector3(0.5f, 0.5f) + offset;

        //NoiseMethod method = Noise.noiseMethods[(int)type][dimensions - 1];
        //float stepSize = 1f / resolution;
        //float amplitude = damping ? strength / frequency : strength;
        //for (int v = 0, y = 0; y <= resolution; y++)
        //{
        //    Vector3 point0 = Vector3.Lerp(point00, point01, y * stepSize);
        //    Vector3 point1 = Vector3.Lerp(point10, point11, y * stepSize);
        //    for (int x = 0; x <= resolution; x++, v++)
        //    {
        //        Vector3 point = Vector3.Lerp(point0, point1, x * stepSize);
        //        NoiseSample sample = Noise.Sum(method, point, frequency, octaves, lacunarity, persistence);
        //        sample = type == NoiseMethodType.Value ? (sample - 0.5f) : (sample * 0.5f);
        //        if (coloringForStrength)
        //        {
        //            colors[v] = coloring.Evaluate(sample.value + 0.5f);
        //            sample *= amplitude;
        //        }
        //        else
        //        {
        //            sample *= amplitude;
        //            colors[v] = coloring.Evaluate(sample.value + 0.5f);
        //        }
        //        vertices[v].y = sample.value;
        //        sample.derivative = qInv * sample.derivative;
        //        if (analyticalDerivatives)
        //        {
        //            normals[v] = new Vector3(-sample.derivative.x, 1f, -sample.derivative.y).normalized;
        //        }
        //        colors[v] = coloring.Evaluate(sample.value + 0.5f);
        //    }
        //}
        //mesh.vertices = vertices;
        //mesh.colors = colors;
        //if (!analyticalDerivatives)
        //{
        //    CalculateNormals();
        //}
        //mesh.normals = normals;
    }
	// Use this for initialization
	void Start () {
        float[] array = new float[]{151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
        140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
        247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
         57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
         74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
         60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
         65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
        200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
         52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
        207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
        119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
        129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
        218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
         81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
        184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
        222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180,
        151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
        140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
        247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
         57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
         74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
         60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
         65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
        200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
         52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
        207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
        119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
        129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
        218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
         81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
        184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
        222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180};
        _material.SetFloatArray("hash",array);
        _material.SetFloat("hashMask", 255);
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    private int currentResolution;
    private Mesh mesh;
    private void OnEnable()
    {
        if (mesh == null)
        {
            mesh = new Mesh();
            mesh.name = "Surface Mesh";
            GetComponent<MeshFilter>().mesh = mesh;
        }
        Refresh();
    }
    private Vector3[] vertices;
    private Vector3[] normals;
    private Color[] colors;

    private void CreateGrid()
    {
        currentResolution = resolution;
        mesh.Clear();
        vertices = new Vector3[(resolution + 1) * (resolution + 1)];
        colors = new Color[vertices.Length];
        normals = new Vector3[vertices.Length];
        Vector2[] uv = new Vector2[vertices.Length];
        float stepSize = 1f / resolution;
        for (int v = 0, z = 0; z <= resolution; z++)
        {
            for (int x = 0; x <= resolution; x++, v++)
            {
                vertices[v] = new Vector3(x * stepSize - 0.5f, 0f, z * stepSize - 0.5f);
                colors[v] = Color.black;
                normals[v] = Vector3.up;
                uv[v] = new Vector2(x * stepSize, z * stepSize);
            }
        }
        mesh.vertices = vertices;
        mesh.colors = colors;
        mesh.normals = normals;
        mesh.uv = uv;

        int[] triangles = new int[resolution * resolution * 6];
        for (int t = 0, v = 0, y = 0; y < resolution; y++, v++)
        {
            for (int x = 0; x < resolution; x++, v++, t += 6)
            {
                triangles[t] = v;
                triangles[t + 1] = v + resolution + 1;
                triangles[t + 2] = v + 1;
                triangles[t + 3] = v + 1;
                triangles[t + 4] = v + resolution + 1;
                triangles[t + 5] = v + resolution + 2;
            }
        }
        mesh.triangles = triangles;
    }
    private void OnDrawGizmosSelected()
    {
        float scale = 1f / resolution;
        if (showNormals && vertices != null)
        {
            Gizmos.color = Color.yellow;
            for (int v = 0; v < vertices.Length; v++)
            {
                Gizmos.DrawRay(vertices[v], normals[v] * scale);
            }
        }
    }
    private void CalculateNormals()
    {
        for (int v = 0, z = 0; z <= resolution; z++)
        {
            for (int x = 0; x <= resolution; x++, v++)
            {
                normals[v] = new Vector3(-GetXDerivative(x, z), 1f, -GetZDerivative(x, z)).normalized;
            }
        }
    }
    private float GetXDerivative(int x, int z)
    {
        int rowOffset = z * (resolution + 1);
        float left, right, scale;
        if (x > 0)
        {
            left = vertices[rowOffset + x - 1].y;
            if (x < resolution)
            {
                right = vertices[rowOffset + x + 1].y;
                scale = 0.5f * resolution;
            }
            else
            {
                right = vertices[rowOffset + x].y;
                scale = resolution;
            }
        }
        else
        {
            left = vertices[rowOffset + x].y;
            right = vertices[rowOffset + x + 1].y;
            scale = resolution;
        }
        return (right - left) * scale;
    }
    private float GetZDerivative(int x, int z)
    {
        int rowLength = resolution + 1;
        float back, forward, scale;
        if (z > 0)
        {
            back = vertices[(z - 1) * rowLength + x].y;
            if (z < resolution)
            {
                forward = vertices[(z + 1) * rowLength + x].y;
                scale = 0.5f * resolution;
            }
            else
            {
                forward = vertices[z * rowLength + x].y;
                scale = resolution;
            }
        }
        else
        {
            back = vertices[z * rowLength + x].y;
            forward = vertices[(z + 1) * rowLength + x].y;
            scale = resolution;
        }
        return (forward - back) * scale;
    }
}
