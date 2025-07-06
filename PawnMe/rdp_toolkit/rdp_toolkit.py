import socket
import subprocess
import os
import tkinter as tk
from tkinter import messagebox


def test_rdp_connectivity(host: str, port: int = 3389, timeout: int = 5) -> bool:
    """
    Test if the RDP port is open on the target host.
    Returns True if connection is successful, False otherwise.
    """
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except Exception:
        return False


def initiate_rdp_connection(host: str, username: str = "", password: str = ""):
    """
    Initiate an RDP connection to the target host.
    On Windows, launches mstsc. On Linux, uses xfreerdp/rdesktop if available.
    """
    if os.name == 'nt':
        cmd = ["mstsc", "/v:{}".format(host)]
        subprocess.Popen(cmd)
    else:
        cmd = ["xfreerdp", "/v:{}".format(host)]
        subprocess.Popen(cmd)


def push_payload(host: str, username: str, password: str, local_path: str, remote_path: str):
    """
    Push a payload (file) to the remote host.
    This is a placeholder; implement SMB or other file transfer as needed.
    """

    print(f"[!] Payload push not implemented. Would send {local_path} to {host}:{remote_path}")


def show_gui():
    def on_test():
        host = entry_host.get().strip()
        if not host:
            messagebox.showerror("Input Error", "Please enter a target domain or IP address.")
            return
        result = test_rdp_connectivity(host)
        if result:
            messagebox.showinfo("RDP Test Result", f"RDP port is OPEN on {host}.")
        else:
            initiate_rdp_connection(host)
            messagebox.showwarning(
                "RDP Test Result",
                f"RDP port is CLOSED or unreachable on {host}.\nAttempted to initiate RDP connection."
            )

    root = tk.Tk()
    root.title("Bluelytning-RDP")
    root.geometry("350x150")

    label = tk.Label(root, text="Enter target domain or IP:")
    label.pack(pady=10)

    entry_host = tk.Entry(root, width=30)
    entry_host.pack(pady=5)

    test_btn = tk.Button(root, text="Test RDP Connectivity", command=on_test)
    test_btn.pack(pady=15)

    root.mainloop()


if __name__ == "__main__":
    show_gui()
