Name:           libxfce4util
Version:        4.20.0
Release:        1%{?dist}
Summary:        Utility library for the Xfce4 desktop environment

License:        LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/libxfce4util/4.20/libxfce4util-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  glib2-devel
BuildRequires:  xfce4-dev-tools >= 4.20.0
BuildRequires:  gettext
BuildRequires:  intltool

%description
Utility library for the Xfce4 desktop environment.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:       glib2-devel

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang libxfce4util

%files -f libxfce4util.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/libxfce4util.so.*

%files devel
%{_includedir}/xfce4/libxfce4util/
%{_libdir}/libxfce4util.so
%{_libdir}/pkgconfig/libxfce4util-1.0.pc
%{_datadir}/gir-1.0/libxfce4util-1.0.gir

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
