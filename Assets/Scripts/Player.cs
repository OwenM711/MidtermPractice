using UnityEngine;

public class Player : MonoBehaviour
{
    public int speed = 10;
    public int jumpValue = 5;

    Rigidbody rb;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up * jumpValue, ForceMode.Impulse);
        }
    }
}
