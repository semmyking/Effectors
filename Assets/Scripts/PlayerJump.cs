using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class PlayerJump : MonoBehaviour
{

    public Vector2 jump;
    private float jumpForce = 2.5f;
    private Rigidbody2D rb;
    private bool flip;
    public bool isGrounded;

    private void Awake()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    private void OnCollisionStay2D(Collision2D other)
    {
        isGrounded = true;

        if (other.gameObject.tag == "object")
        {
            isGrounded = false;
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.W) && isGrounded)
        {
            Vector3 doJump = new Vector3(jump.x * (flip ? -1 : 1), jump.y);
            rb.AddForce(doJump * jumpForce, ForceMode2D.Impulse);
            isGrounded = false;
        }
    }
}
