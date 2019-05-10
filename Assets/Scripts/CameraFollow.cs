using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform player;
    public float cameraSpeed;
    private Vector3 offset;

    private void Start()
    {
        offset = Camera.main.transform.position - player.position;
    }
    private void Update()
    {
        transform.position = Vector3.Lerp(transform.position, player.position + offset, cameraSpeed * Time.deltaTime);
    }
}
