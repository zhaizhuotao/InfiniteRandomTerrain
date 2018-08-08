using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
public class CameraMove : MonoBehaviour {

	// Use this for initialization
	public float PlayerSpeed;
	private Vector3 screenPoint; 
	private Vector3 offset;
	private float m_StartMousePointX;
	private float m_StartMousePointY;
	private bool overGUIElement = false;
	void Start () 
	{
	}

	void TurnObserver()
	{
		if(Input.GetMouseButtonDown(0)) 
 		{ 
			
			m_StartMousePointX = Input.mousePosition.x;
			m_StartMousePointY = Input.mousePosition.y;
 		}
		
 		if(Input.GetMouseButton(0)) 
 		{ 
			float l_CurrentMousePointX = Input.mousePosition.x;
			float l_CurrentMousePointY = Input.mousePosition.y;
			float l_dis_x = (l_CurrentMousePointX - m_StartMousePointX) / 4;
			float l_dis_y = (l_CurrentMousePointY - m_StartMousePointY) / 4;
			m_StartMousePointX = l_CurrentMousePointX;
			m_StartMousePointY = l_CurrentMousePointY;
			
			if(Mathf.Abs(l_dis_x) >= Mathf.Abs(l_dis_y))
			{
				Vector3 l_ori = transform.eulerAngles;
				transform.eulerAngles = new Vector3(l_ori.x,l_ori.y + l_dis_x, 0);
			}
			else
			{
				Vector3 l_ori = transform.eulerAngles;
				transform.eulerAngles = new Vector3(l_ori.x - l_dis_y,l_ori.y, 0);
			}
		} 
	}
	private bool _mouseInAvailableArea = false;
	public void EnterMouseAvailableArea()
	{
		_mouseInAvailableArea = true;
	}
	public void ExitMouseAvailableArea()
	{
		_mouseInAvailableArea = false;
	}
	// Update is called once per frame
	void Update () 
	{
        if (EventSystem.current != null)
        {
            if (EventSystem.current.IsPointerOverGameObject())
            {
                return;
            }
        }
		//Game模式操控
		float outToMove = Input.GetAxisRaw("Horizontal")* PlayerSpeed * Time.deltaTime; 
		transform.Translate(Vector3.right * outToMove);
		
		float outToMove_1 = Input.GetAxisRaw("Vertical")* PlayerSpeed * Time.deltaTime;
		transform.Translate(Vector3.forward * outToMove_1);
		TurnObserver();
		//todo鼠标滚轮需要自己在InputManager中进行定义
		float middleScroll = Input.GetAxis ("Mouse ScrollWheel");
		if (middleScroll > 0)
			PlayerSpeed += 5;
		if (middleScroll < 0)
			PlayerSpeed -= 5;
	}
	/// <summary>

}
